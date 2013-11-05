Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab3KEGC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:02:56 -0500
Received: from intranet.asianux.com ([58.214.24.6]:62690 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3KEGCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:02:55 -0500
X-Spam-Score: -100.8
Message-ID: <527889CB.50807@asianux.com>
Date: Tue, 05 Nov 2013 14:01:47 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] get_maintainer: Improve "Author:" rolestats
References: <52738E90.6040104@asianux.com>  <1383330777.3042.2.camel@joe-AO722> <52750739.6040706@gmail.com>  <1383602096.28651.8.camel@joe-AO722> <52785676.8030801@asianux.com>  <527859D9.30109@asianux.com> <1383629008.4387.0.camel@joe-AO722>  <5278853E.2000600@asianux.com> <1383630652.4387.8.camel@joe-AO722>
In-Reply-To: <1383630652.4387.8.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 01:50 PM, Joe Perches wrote:
> On Tue, 2013-11-05 at 13:42 +0800, Chen Gang wrote:
>> On 11/05/2013 01:23 PM, Joe Perches wrote:
>>> On Tue, 2013-11-05 at 10:37 +0800, Chen Gang wrote:
> 
>> (if so, it seems the related
>> patch need be re-committed again by the related author).
> 
> No it doesn't mean that.
> 
> Prior to this patch, get_maintainer only used "sign-off-by"
> style lines to find interested parties to send patches to
> when the MAINTAINERS file did not have a specific section
> entry with a matching file pattern to the files that that
> the patch modified.
> 
> And there was a defect in the script when no commit history
> at all was found for the files modified during the period
> selected (1 year of git log history by default)
> 
> Now, using this newly modified get_maintainer.pl script,
> the commit authors shown in the git log history as well as
> the commit signers are selected.
> 
> If there is no git history, the script defect is also fixed.
> 

Yeah, our "get_maintainer.pl" need be smart enough to bear it (this
patch let our "get_maintainer.pl" smart enough).

But for this kind of patch, need it re-commit again? (for me, I
recommend to re-commit it again by the related author).


Thanks.
-- 
Chen Gang

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab3KEFn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 00:43:56 -0500
Received: from intranet.asianux.com ([58.214.24.6]:30481 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3KEFnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 00:43:55 -0500
X-Spam-Score: -100.8
Message-ID: <5278853E.2000600@asianux.com>
Date: Tue, 05 Nov 2013 13:42:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] get_maintainer: Improve "Author:" rolestats
References: <52738E90.6040104@asianux.com>  <1383330777.3042.2.camel@joe-AO722> <52750739.6040706@gmail.com>  <1383602096.28651.8.camel@joe-AO722> <52785676.8030801@asianux.com>  <527859D9.30109@asianux.com> <1383629008.4387.0.camel@joe-AO722>
In-Reply-To: <1383629008.4387.0.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 01:23 PM, Joe Perches wrote:
> On Tue, 2013-11-05 at 10:37 +0800, Chen Gang wrote:
>> But after I let it pure next-20131101 ("git reset HEAD^; git stash"), it
>> still cause this issue.
> 
> It's also because:
> 
>>>> Also, there's a defect in function vcs_find_signers.
>>>> It should only return the commit count and array references.
>>>>
>>>> If there are no signers in the commit history interval specified,
>>>> then the "authors" array is added to the "signers" array and
>>>> returned as a single array.
> 
> 
> 
> 

OK, thanks. Do you mean: in pure next-20131101 contents an author which
commit a patch, but not signed himself? (if so, it seems the related
patch need be re-committed again by the related author).


Thanks.
-- 
Chen Gang

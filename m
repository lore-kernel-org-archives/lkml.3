Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3KEGhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:37:48 -0500
Received: from intranet.asianux.com ([58.214.24.6]:19759 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3KEGhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:37:47 -0500
X-Spam-Score: -100.8
Message-ID: <527891F9.8040100@asianux.com>
Date: Tue, 05 Nov 2013 14:36:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: Re: [PATCH -next] get_maintainer: Improve "Author:" rolestats
References: <52738E90.6040104@asianux.com>  <1383330777.3042.2.camel@joe-AO722> <52750739.6040706@gmail.com>  <1383602096.28651.8.camel@joe-AO722> <52785676.8030801@asianux.com>  <527859D9.30109@asianux.com> <1383629008.4387.0.camel@joe-AO722>  <5278853E.2000600@asianux.com> <52788606.5070002@asianux.com>  <1383630867.4387.11.camel@joe-AO722> <52788A50.6000403@asianux.com> <1383632181.4387.18.camel@joe-AO722>
In-Reply-To: <1383632181.4387.18.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 02:16 PM, Joe Perches wrote:
> On Tue, 2013-11-05 at 14:04 +0800, Chen Gang wrote:
>> On 11/05/2013 01:54 PM, Joe Perches wrote:
>>> On Tue, 2013-11-05 at 13:45 +0800, Chen Gang wrote:
>>>>> If really as what I guess above (some patches no Signed-of-by), is there
>>>>> a tool to check and find this issue in time?
>>> scripts/checkpatch.pl bleats a message on missing sign-offs.
>>
>> Yeah, the author/maintainer can use it for checking.
>>
>> But do we have additional tools to let the version tree integrator (e.g.
>> sfr) notice about it?
> 
> git pre-commit hooks work.
> 
> btw: there's some development efforts going on
>      that might help here eventually.
> 
> Read this thread:
> https://lkml.org/lkml/2013/10/26/158
> 

OK, thanks. It seems it is about commit one patch, and it also seems no
"git pre-commit" command (my git version is "git version 1.7.7.6").

And do we have a tool to type a command to check all patches whether
missing sign-offs? (I guess, the version integrator need not check patch
one by one only for whether contents sign-offs).

Oh, I forgot one thing, the original "scripts/get_maintainers.pl" (e.g.
in next-20130927), it is already smart enough. So can we treat our patch
as the fix patch for the latest changes?


Thanks.
-- 
Chen Gang

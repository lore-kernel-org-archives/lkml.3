Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3KEGFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:05:08 -0500
Received: from intranet.asianux.com ([58.214.24.6]:50408 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3KEGFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:05:06 -0500
X-Spam-Score: -100.8
Message-ID: <52788A50.6000403@asianux.com>
Date: Tue, 05 Nov 2013 14:04:00 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: Re: [PATCH -next] get_maintainer: Improve "Author:" rolestats
References: <52738E90.6040104@asianux.com>  <1383330777.3042.2.camel@joe-AO722> <52750739.6040706@gmail.com>  <1383602096.28651.8.camel@joe-AO722> <52785676.8030801@asianux.com>  <527859D9.30109@asianux.com> <1383629008.4387.0.camel@joe-AO722>  <5278853E.2000600@asianux.com> <52788606.5070002@asianux.com> <1383630867.4387.11.camel@joe-AO722>
In-Reply-To: <1383630867.4387.11.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 01:54 PM, Joe Perches wrote:
> On Tue, 2013-11-05 at 13:45 +0800, Chen Gang wrote:
>> > If really as what I guess above (some patches no Signed-of-by), is there
>> > a tool to check and find this issue in time?
> scripts/checkpatch.pl bleats a message on missing sign-offs.

Yeah, the author/maintainer can use it for checking.

But do we have additional tools to let the version tree integrator (e.g.
sfr) notice about it?


Thanks.
-- 
Chen Gang

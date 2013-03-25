Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3CYFjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 01:39:22 -0400
Received: from intranet.asianux.com ([58.214.24.6]:4158 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3CYFjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 01:39:21 -0400
X-Spam-Score: -100.8
Message-ID: <514FE2EB.7050002@asianux.com>
Date: Mon, 25 Mar 2013 13:38:51 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>, matt@ozlabs.org,
        imunsie@au1.ibm.com, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PowerPC:kernel: make additional room in exception vector
 area
References: <51428C81.6000204@asianux.com> <25841.1363323174@ale.ozlabs.ibm.com> <5142AE27.7060003@asianux.com> <514AA0D9.1090509@asianux.com> <10123.1363906486@ale.ozlabs.ibm.com> <514C0061.8080004@asianux.com> <29457.1364169818@ale.ozlabs.ibm.com> <514FA8F3.1030102@asianux.com> <20130325161435.ffff94805826bc7cad2c7de4@canb.auug.org.au>
In-Reply-To: <20130325161435.ffff94805826bc7cad2c7de4@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年03月25日 13:14, Stephen Rothwell wrote:
> Hi all,
> 
> On Mon, 25 Mar 2013 09:31:31 +0800 Chen Gang <gang.chen@asianux.com> wrote:
>> >
>> >   The FWNMI region is fixed at 0x7000 and the vector are now overflowing
>> >   that with allmodconfig. Fix that by moving slb_miss_realmode code out
>> >   of that region as it doesn't need to be that close to the call sites
>> >   (it is a _GLOBAL function)
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  arch/powerpc/kernel/exceptions-64s.S |  144 +++++++++++++++++-----------------
>> >  1 files changed, 72 insertions(+), 72 deletions(-)
> Thanks, Chen,
> 
> I have applied this to linux-next today and pending the builds overnight,
> will send it to Linus tomorrow or Wednesday.

  thanks.

  :-)

-- 
Chen Gang

Asianux Corporation

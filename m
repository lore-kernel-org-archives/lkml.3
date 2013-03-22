Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3CVGqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 02:46:55 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28286 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3CVGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 02:46:54 -0400
X-Spam-Score: -100.8
Message-ID: <514BFE3E.5000906@asianux.com>
Date: Fri, 22 Mar 2013 14:46:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Michael Neuling <mikey@neuling.org>, sfr@canb.auug.org.au,
        "paulus@samba.org" <paulus@samba.org>, matt@ozlabs.org,
        imunsie@au1.ibm.com, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] PowerPC: kernel: cross compiling issue with allmodconfig
References: <51428C81.6000204@asianux.com>  <25841.1363323174@ale.ozlabs.ibm.com> <5142AE27.7060003@asianux.com>  <514AA0D9.1090509@asianux.com> <514AC418.1070806@gmail.com> <1363869499.17680.25.camel@pasglop>
In-Reply-To: <1363869499.17680.25.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年03月21日 20:38, Benjamin Herrenschmidt wrote:
> On Thu, 2013-03-21 at 16:26 +0800, Chen Gang F T wrote:
>> >   it seems:
>> >     only move slb_miss_realmode to the end, can fix this issue without negative effect.
> Thanks. I'm currently on vacation, I'll have a closer look when I'm back
> unless Stephen or Paulus wants to shoot that to Linus while I'm
> away.
> 

  ok, I prefer to wait you back to have a closer look.

  thanks.

  :-)


> Cheers,
> Ben.
> 


-- 
Chen Gang

Asianux Corporation

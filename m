Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423282Ab3CWCv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 22:51:58 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45153 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422924Ab3CWCv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 22:51:57 -0400
Message-ID: <514D18A8.7080904@gmail.com>
Date: Sat, 23 Mar 2013 10:51:20 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoder Stuart-B08248 <B08248@freescale.com>
CC: Michael Neuling <mikey@neuling.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Chen Gang <gang.chen@asianux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "paulus@samba.org" <paulus@samba.org>,
        "matt@ozlabs.org" <matt@ozlabs.org>,
        "imunsie@au1.ibm.com" <imunsie@au1.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] PowerPC: kernel: cross compiling issue with allmodconfig
References: <51428C81.6000204@asianux.com> <25841.1363323174@ale.ozlabs.ibm.com> <5142AE27.7060003@asianux.com> <514AA0D9.1090509@asianux.com> <514AC418.1070806@gmail.com> <14121.1363908062@ale.ozlabs.ibm.com> <9F6FE96B71CF29479FF1CDC8046E150358CDE5@039-SN1MPN1-002.039d.mgd.msft.net>
In-Reply-To: <9F6FE96B71CF29479FF1CDC8046E150358CDE5@039-SN1MPN1-002.039d.mgd.msft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年03月23日 03:17, Yoder Stuart-B08248 wrote:
> allmodconfig is creating config combinations that don't
> happen in a normal build (at least currently)-- 64-bit build
> that enables EPAPR_PARAVIRT but not PPC_BOOK3E_64.

  if it should not happen.
    can we add dependency to let it will never happen in any config combinations ?
      let allmodconfig can not create this config combinamtions:
        "64-bit build that enables EPAPR_PARAVIRT but not PPC_BOOK3E_64".

  thanks.

-- 
Chen Gang

Flying Transformer

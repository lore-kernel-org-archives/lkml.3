Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3IKXqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:46:35 -0400
Received: from mout.gmx.net ([212.227.15.18]:64645 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab3IKXqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:46:34 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net, jean-luc.blanc@st.com
Subject: Re: [tpmdd-devel] TPM: STMicroelectronics st33 driver SPI
Date: Thu, 12 Sep 2013 01:47:00 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.9; KDE/4.10.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, linux-kernel@vger.kernel.org,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        adlai@linux.vnet.ibm.com,
        "Rajiv Andrade \(mail@srajiv.net\)" <mail@srajiv.net>,
        andy.shevchenko@gmail.com,
        "Sirrix AG \(tpmdd@sirrix.com\)" <tpmdd@sirrix.com>
References: <35286B1AE75A7C47BFF0870081A31B4B4C87C3BED8@SAFEX1MAIL4.st.com> <201308230054.34660.PeterHuewe@gmx.de> <alpine.DEB.2.02.1308262145290.13156@fishsauce>
In-Reply-To: <alpine.DEB.2.02.1308262145290.13156@fishsauce>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201309120147.00991.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:i/q1Ks9vK/FHqxcWCVrgWoaaA/01uBFeznwpCnM9SxIsUlEe9jR
 Ei6+esBJdzs/4So9hgppZboMpV8+waKnrVFzvvDygOC+sNZ5DF1j8eBfkv07Fy0R6drRYNl
 p6fjdrHjOlpMhpZywgdByf8m05HSQb5xtGTbhizXUeq5pKGZXwNewiE+aFoDCtErTXi3XHU
 yn3ar7nFKfef9g8/elL8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling it I get
WARNING: modpost: missing MODULE_LICENSE() in 
drivers/char/tpm/tpm_spi_stm_st33.o

Thanks,
Peter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaLPVTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:19:35 -0500
Received: from mout.gmx.net ([212.227.17.21]:60166 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbaLPVTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:19:33 -0500
MIME-Version: 1.0
Message-ID: <trinity-c582edfe-4951-4a31-911d-db0c6f723157-1418764766771@3capp-gmx-bs15>
From: "Peter Huewe" <PeterHuewe@gmx.de>
To: "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc: "Ashley Lai" <ashley@ashleylai.com>,
        "Marcel Selhorst" <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, stefanb@linux.vnet.ibm.com,
        linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net
Subject: Aw: Re: [PATCH v10 0/8] TPM 2.0 support
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Dec 2014 22:19:26 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20141215201757.GA27923@intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>,
 <20141215201757.GA27923@intel.com>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:5W8ec5nsNhfSdHYzvVlG+X/eMeI/dWm297cOIE4V52I
 j29JRI4K2qKDQSvhOdlkX3g1YvuoFcdIHUOwLJNaxdkgQnJQdy
 FweRTyIrv6GSl5UEOzvhfdLkRXTQs8IY/Wm9T0OC8mfAEXNWuH
 V42eAKmiZYU6rcw8OghsBXqrbBZPcptAesfUpMBYc3l6FWFy9n
 wC/h96vFujGba/ctlsOQsT6veiA5TMGUgTOQqjrX7+HzrqwXqe
 u9/Yc/IT0RNEI54WpomxhPizPWpg5E9uyGMeGIBmg0EeSpuNHD Z8kfa0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, what do you think? Are we now settled with this?

Meh...
It does not recognize my tpm20 with force=1 :( :( :(
Probably since I don't have a machine with bios integration -> no tpm startup,
and your startup is returned with RC_SIZE :(



 rmmod tpm; modprobe tpm_tis force=1 ; dmesg 
modprobe: ERROR: could not insert 'tpm_tis': No such device
[   77.744050] tpm_tis tpm_tis: 2.0 TPM (device-id 0x1A, rev-id 16)
[   77.816049] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
[   77.888043] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
[   77.960043] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
[   77.960057] genirq: Flags mismatch irq 6. 00000080 (tpm0) vs. 00000000 (floppy)
[   77.960067] tpm_tis tpm_tis: Unable to request irq: 6 for probe
[   77.960073] genirq: Flags mismatch irq 7. 00000080 (tpm0) vs. 00000000 (parport0)
[   77.960077] tpm_tis tpm_tis: Unable to request irq: 7 for probe
[   77.960082] genirq: Flags mismatch irq 8. 00000080 (tpm0) vs. 00000000 (rtc0)
[   77.960087] tpm_tis tpm_tis: Unable to request irq: 8 for probe
[   78.032041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
[   78.104043] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
[   78.176041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
[   78.248041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
[   78.320041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
[   78.392040] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
[   78.464041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
[   78.524041] tpm_tis tpm_tis: A TPM error (256) occurred continue selftest
[   78.524048] tpm_tis tpm_tis: Firmware has not started TPM
[   78.596041] tpm_tis tpm_tis: A TPM error (149) occurred attempting to start the TPM
[   78.596048] tpm_tis tpm_tis: TPM self test failed


;(
Peter

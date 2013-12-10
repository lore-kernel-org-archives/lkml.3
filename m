Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3LJMap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:30:45 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:41176 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3LJMan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:30:43 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
To: Matt Sealey <neko@bakuhatsu.net>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, matt.fleming@intel.com,
        Roy Franz <roy.franz@linaro.org>, Mark Salter <msalter@redhat.com>,
        Patch Tracking <patches@linaro.org>, linaro-uefi@lists.linaro.org,
        Mark Rutland <mark.rutland@arm.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
In-Reply-To: <CAHCPf3s_SXYXLRwvn7tzqTCQ-gB=emRMK_dXkEmw_HWigiD7Mw@mail.gmail.com>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org> < 1385656883-4420-2-git-send-email-leif.lindholm@linaro.org> < CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com> < 20131202210719.GQ24997@rocoto.smurfnet.nu> < CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com> < 20131204224447.GA19265@srcf.ucam.org> < CAHCPf3s_SXYXLRwvn7tzqTCQ-gB=emRMK_dXkEmw_HWigiD7Mw@mail.gmail.com>
Date: Tue, 10 Dec 2013 12:30:35 +0000
Message-Id: <20131210123035.D1586C40A27@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Dec 2013 11:20:45 -0600, Matt Sealey <neko@bakuhatsu.net> wrote:
> On Wed, Dec 4, 2013 at 4:44 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Wed, Dec 04, 2013 at 03:06:47PM -0600, Matt Sealey wrote:
> Grant suggested I should propose some patches; sure, if I'm not otherwise busy.
> 
> Maybe the Linaro guys can recommend a platform (real or emulated) that
> would be best to test it on with the available UEFI?

Roy Franz (cc'd) has got UEFI running under QEMU. A few modifications
were required to both stock UEFI and QEMU. I'm not sure what the status
of mainlining those patches is. I think there are still a few things
that Roy has to fix, but you should be able to get the current patches
from him to get going.

g.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3DZOfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:35:19 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46545 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3DZOfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:35:18 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD1E51@USINDEM103.corp.hds.com>
References: <tip-e14ab23dde12b80db4c94b684a2e485b72b16af3@git.kernel.org>
	<A5ED84D3BB3A384992CBB9C77DEDA4D41AFD1E51@USINDEM103.corp.hds.com>
Date: Fri, 26 Apr 2013 15:35:16 +0100
Message-ID: <CAL01qpumczY1Rw9tYqVDkkA0CDE45bNxXCY6bH0cNHhrzLS8ww@mail.gmail.com>
Subject: Re: [tip:x86/efi2] efivars: efivar_entry API
From: "Fleming, Matt" <matt.fleming@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "jk@ozlabs.org" <jk@ozlabs.org>, "teg@jklm.no" <teg@jklm.no>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mikew@google.com" <mikew@google.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 15:28, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> Matt,
>
> I built a tip tree With CONFIG_EFIVAR_FS=y.
> But, I can't see any entries in the directory of /sys/firmware/efi/efivarfs...
>
> I'm not sure if it is a problem.
> Just let you know.

Did you mount the efivarfs file system there?

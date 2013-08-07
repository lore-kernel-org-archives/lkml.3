Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3HGFfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:35:21 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:56841 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab3HGFfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:35:20 -0400
MIME-Version: 1.0
In-Reply-To: <5201D777.8060303@linux.vnet.ibm.com>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
	<51FA3B02.7060004@linux.vnet.ibm.com>
	<3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com>
	<CA+8MBbLuhVDCb26ag3AH0vXrP4MXHLxS5aVn8pTi4=qL1NdR5w@mail.gmail.com>
	<CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com>
	<51FFDC8B.7010909@linux.vnet.ibm.com>
	<CA+8MBb+1LpR+Cx=84WZT98U5eqZcm1KriUP75aCg+uSrXrb3Yw@mail.gmail.com>
	<51FFFFEB.3030907@linux.vnet.ibm.com>
	<CA+8MBbK9oZJO+RJGC-7riO=Kz=UbRcAvQ-nDi=2GLyvEDpoc7g@mail.gmail.com>
	<CA+8MBbKA+P4vs3utSKQ-LPMW3ybrWOp=f3FH6ahv1YtwnMm5KA@mail.gmail.com>
	<5201A9BD.4090503@linux.vnet.ibm.com>
	<CA+8MBbJS0Dymn4OABi-rW9M5Bw-ZZ6DaEjQOW-oki+4ge4BDtg@mail.gmail.com>
	<5201D777.8060303@linux.vnet.ibm.com>
Date: Tue, 6 Aug 2013 22:35:19 -0700
Message-ID: <CA+8MBb+pkKpaEDs6J_XbzM3wzady2MjdU+jcDP+jH1f1VBxG5w@mail.gmail.com>
Subject: Re: [PATCH 00/11] Add compression support to pstore
From: Tony Luck <tony.luck@gmail.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 10:13 PM, Aruna Balakrishnaiah
<aruna@linux.vnet.ibm.com> wrote:
> How is it with erst and efivars?

ERST is at the whim of the BIOS writer (the ACPI standard doesn't provide any
suggestions on record sizes).  My systems support ~6K record size.

efivars has, IIRC, a 1k limit coded in the Linux back end.

-Tony

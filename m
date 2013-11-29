Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3K2CcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:32:16 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:62085 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3K2CcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:32:13 -0500
MIME-Version: 1.0
In-Reply-To: <5297FBF6.2060802@gtsys.com.hk>
References: <1385690880-32303-1-git-send-email-chris.ruehl@gtsys.com.hk>
	<CAOMZO5DZ2AtM-6m9C54hEi60V=c95HzYaNW6YkiZjBy+8QWfaw@mail.gmail.com>
	<5297FBF6.2060802@gtsys.com.hk>
Date: Fri, 29 Nov 2013 00:32:12 -0200
Message-ID: <CAOMZO5ACZwGdnv3RwsLX-wHNMHyAJ8HNWyoqLTSN696fc4h=Uw@mail.gmail.com>
Subject: Re: [PATCH 3/3] usb: chipidea: hw_phymode_configure moved before ci_usb_phy_init
From: Fabio Estevam <festevam@gmail.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:29 AM, Chris Ruehl <chris.ruehl@gtsys.com.hk> wrote:

> yeah, the hw_phymode_configure() was in the probe but not called before the
> ci_usb_phy_init(ci) which triggers the inits in phy-generic.c (in my case)
>
> My pending patches relay on this.
>
> Did you move the hw_phy before the ci_usb_phy_init too ?

Ah, ok. It is a different issue then. Sorry for the noise.

Regards,

Fabio Estevam

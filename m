Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaKCNyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:54:33 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:33297 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaKCNy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:54:28 -0500
MIME-Version: 1.0
X-Originating-IP: [84.208.172.182]
In-Reply-To: <mj+md-20141101.174026.23374.albireo@ucw.cz>
References: <CAG-2HqXsEBB_nxUF4gza-eTsUjmysYR7iPEjJPUFyR1rC2KGMg@mail.gmail.com>
 <CAPXgP12MLL_Z5gyrCndQLRT6SR_TJi9xHp1HkHMX1ahwnxx3yw@mail.gmail.com>
 <mj+md-20131215.091609.28546.nikam@ucw.cz> <CAPXgP10+1WtX8_xN+QSHvKws01hbKhP3FN95sXk9EtezdSPtqg@mail.gmail.com>
 <mj+md-20131215.110132.29802.nikam@ucw.cz> <CAG-2HqUGcBB1-YUvLZpqm1EZ69OSksa+iGcCEqVWxYsehDqx8Q@mail.gmail.com>
 <CAG-2HqWYZtTMNRvLwWRy-5_5yb=EasiWzpL2xc0_42SyP=bg1w@mail.gmail.com>
 <CAG-2HqVS1avGdvi6SFc1dq0sCzcA4z5sZUBH4WhpNN87tZrnxA@mail.gmail.com>
 <mj+md-20140212.194230.3341.nikam@ucw.cz> <CAG-2HqUN3Ftdd=3XSe-et3pgXy71Fu9DbMqREQDycwL4kD9Paw@mail.gmail.com>
 <mj+md-20141101.174026.23374.albireo@ucw.cz>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 3 Nov 2014 14:54:06 +0100
Message-ID: <CAG-2HqV10ar6N+khr-s01d+2keL+o3T0itPvN2xe6q0UERgf1Q@mail.gmail.com>
Subject: Re: udev/hwdb support in pciutils (Re: [PATCH RESEND][pciutils]
 libpci: pci_id_lookup - add udev/hwdb support)
To: Martin Mares <mj@ucw.cz>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Sat, Nov 1, 2014 at 6:51 PM, Martin Mares <mj@ucw.cz> wrote:
> The support for hwdb has finally landed in mainline pciutils.
>
> I have modified your patch to bring it closer to the rest of device
> naming logic. Namely:

Great! Thanks for merging this, and for working on it.

> Aside of the README, everything should be ready for a public release.
> Could you please verify that it still works for you?

I can verify that it still works as expected, so it is good to go as
far as I'm concerned.

Cheers,

Tom

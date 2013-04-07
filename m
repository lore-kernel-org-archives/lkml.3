Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab3DGJjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 05:39:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58083 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab3DGJjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 05:39:22 -0400
MIME-Version: 1.0
Date: Sun, 7 Apr 2013 02:39:20 -0700
Message-ID: <CAKbGBLgyC5fJ0P6aYL_hbAWUcOz9ZuNEDectZOiZ_KaK-pTBJg@mail.gmail.com>
Subject: Portege Z830 and Tecra R840 failing to resume from suspend
From: Steven Noonan <steven@uplinklabs.net>
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Cc: Artur Pinheiro <agp121@licas.org>, Aaron Lu <aaron.lu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla bug: https://bugzilla.kernel.org/show_bug.cgi?id=42977

Can someone please give this bug some attention? Aaron Lu from Intel
has been adding people to the bug CC list but nobody seems to be
responding, and per his suggestion I'm mailing the list.

The Z830 and R840 suspend successfully but do not resume without the
extra udelay added by acpi_sleep=s3_beep.

We haven't found any 64-bit kernel builds so far which resume
successfully. As for 32-bit kernels, I haven't tested them myself, but
Artur in the bugzilla (CC'd) has only successfully resumed his R840
with a 32-bit kernel.

- Steven

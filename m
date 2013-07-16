Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab3GPNcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:32:53 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:64554 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab3GPNcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:32:41 -0400
Message-ID: <1373981554.1956.5.camel@ThinkPad-X230.localdomain>
Subject: Re: [Update][PATCH] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-acpi@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>, daniel.vetter@ffwll.ch,
        seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Date: Tue, 16 Jul 2013 17:32:34 +0400
In-Reply-To: <1683364.CdnoW81WLH@vostro.rjw.lan>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <12270512.1rshgKaUug@vostro.rjw.lan> <51DA7190.6080208@gmail.com>
	 <1683364.CdnoW81WLH@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. I found regression in user-space. In GNOME (maybe and other DEs) we no longer see switch status of backlight.

-- 
Igor Gnatenko
Fedora release 19 (Schrödinger’s Cat)
Linux 3.11.0-0.rc0.git7.1.fc20.x86_64


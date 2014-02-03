Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaBCDOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 22:14:07 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:54041 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaBCDOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 22:14:05 -0500
MIME-Version: 1.0
In-Reply-To: <52EF0294.2090103@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
	<CAKb7Uvg4Bqy1tHetVZBe=aekFDbgrGygc-evnSXxsoGqgoTA8A@mail.gmail.com>
	<52EF0294.2090103@nvidia.com>
Date: Sun, 2 Feb 2014 22:14:04 -0500
X-Google-Sender-Auth: oPUbMHVicNEqTMPDD0VgRifcCDA
Message-ID: <CAKb7UvgSpy7wwpg+Fb8V678DvkrqGdcuciTF136VcktJb9-Wiw@mail.gmail.com>
Subject: Re: [RFC 00/16] drm/nouveau: initial support for GK20A (Tegra K1)
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>, Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 2, 2014 at 9:44 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> One beginner question: is it appropriate to send kernel patches to the
> nouveau list in addition to dri-devel? The moderation messages I receive
> make me think that this list might rather be intended for general
> discussion.

I usually do. The main thing is to make sure that they're To: Ben,
since he's the one who will be ultimately be picking them up. I think
that if you're not subscribed, all the lists.freedesktop.org lists
moderate you, but dri-devel is configured not to tell you about it.
Also I've been getting bounce messages from nouveau@ complaining of
too many cc's and so it's getting auto-moderated -- not sure who, if
anyone, is an admin of the nouveau list. Hopefully someone :)

  -ilia

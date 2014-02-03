Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaBCDl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 22:41:29 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:43150 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaBCDl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 22:41:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAKb7UvgSpy7wwpg+Fb8V678DvkrqGdcuciTF136VcktJb9-Wiw@mail.gmail.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
	<CAKb7Uvg4Bqy1tHetVZBe=aekFDbgrGygc-evnSXxsoGqgoTA8A@mail.gmail.com>
	<52EF0294.2090103@nvidia.com>
	<CAKb7UvgSpy7wwpg+Fb8V678DvkrqGdcuciTF136VcktJb9-Wiw@mail.gmail.com>
Date: Mon, 3 Feb 2014 13:41:27 +1000
Message-ID: <CACAvsv6TpyWsKfg0Y9Mjn_TDOWw6yzD_5vfCfycgLnPwU5_ccA@mail.gmail.com>
Subject: Re: [RFC 00/16] drm/nouveau: initial support for GK20A (Tegra K1)
From: Ben Skeggs <skeggsb@gmail.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>, Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 1:14 PM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> On Sun, Feb 2, 2014 at 9:44 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> One beginner question: is it appropriate to send kernel patches to the
>> nouveau list in addition to dri-devel? The moderation messages I receive
>> make me think that this list might rather be intended for general
>> discussion.
>
> I usually do. The main thing is to make sure that they're To: Ben,
> since he's the one who will be ultimately be picking them up. I think
> that if you're not subscribed, all the lists.freedesktop.org lists
> moderate you, but dri-devel is configured not to tell you about it.
> Also I've been getting bounce messages from nouveau@ complaining of
> too many cc's and so it's getting auto-moderated -- not sure who, if
> anyone, is an admin of the nouveau list. Hopefully someone :)
The Nouveau list seems the most appropriate.  There's not really any
need to explicitly CC me either, I do watch the list :)

>
>   -ilia
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

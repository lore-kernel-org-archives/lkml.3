Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaBBTK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 14:10:58 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:59416 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaBBTK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 14:10:56 -0500
MIME-Version: 1.0
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Date: Sun, 2 Feb 2014 14:10:56 -0500
X-Google-Sender-Auth: tOsng54NU5iRg7O1HNiDHSzbR8Q
Message-ID: <CAKb7Uvg4Bqy1tHetVZBe=aekFDbgrGygc-evnSXxsoGqgoTA8A@mail.gmail.com>
Subject: Re: [RFC 00/16] drm/nouveau: initial support for GK20A (Tegra K1)
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>, Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-tegra@vger.kernel.org, Terje Bergstrom <tbergstrom@nvidia.com>,
        Ken Adams <KAdams@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Fri, Jan 31, 2014 at 10:16 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> I guess my email address might surprise some of you, so let me anticipate some
> questions you might have. :P Yes, this work is endorsed by NVIDIA. Several other
> NVIDIAns (CC'd), including core GPU experts, have provided significant technical
> guidance and will continue their involvement. Special thanks go to Terje
> Bergstrom and Ken Adams for their invaluable GPU expertise, and Thierry Reding
> (at FOSDEM this weekend) for help with debugging and user-space testing.
>
> Let me also stress that although very exciting, this effort is still
> experimental, so I would like to make sure that nobody makes excessive
> expectations based on these few patches. The scope of this work is strictly
> limited to Tegra (although given the similarities desktop GPU support will
> certainly benefit from it indirectly), and we do not have any plan to work on
> user-space support. So do not uninstall that proprietary driver just yet. ;)
>
> With this being clarified, we are looking forward to getting your feedback and
> working with you guys to bring and improve Tegra K1 support into Nouveau! :)

I've sent a couple of fairly trivial comments, as you saw, and I
suspect that others with a better understanding of the guts will have
more substantial architectural feedback, esp after the weekend/FOSDEM.
However, since no one's said it already -- welcome to Nouveau!

>From the looks of it, you could bring up a full open-source stack with
your patches (i.e. Xorg + nouveau DDX + mesa) and use PRIME to render
stuff (assuming the actual display hw has an X ddx). Although I
suspect that you're going to want to use your own drivers. Still a
little curious if you've tried the open-source stack and whether it
worked. [Not sure what the status is of render-node support is in
mesa, but perhaps it's enough to try running piglit tests, if you
can't get X going with the display HW.]

  -ilia

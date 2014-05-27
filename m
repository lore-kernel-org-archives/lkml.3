Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaE0URT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:17:19 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34930 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaE0URS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:17:18 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: handle NULL node in of_get_next_available_child
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <CAGVrzcYKCGXbOR1FRaOLxjPeaFEq6skgUvG_i4nqGSdJBUZRqQ@mail.gmail.com>
References: <1400874192-29400-1-git-send-email-f.fainelli@gmail.com>
	<20140527111930.696AAC4156C@trevor.secretlab.ca>
	<CAGVrzcYKCGXbOR1FRaOLxjPeaFEq6skgUvG_i4nqGSdJBUZRqQ@mail.gmail.com>
Date: Tue, 27 May 2014 21:17:11 +0100
Message-Id: <20140527201711.553B8C40BD2@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 10:36:10 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> Hi Grant,
> 
> 2014-05-27 4:19 GMT-07:00 Grant Likely <grant.likely@linaro.org>:
> > On Fri, 23 May 2014 12:43:11 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >> Add an early check for the node argument in
> >> of_get_next_available_child() to avoid dereferencing a NULL node pointer
> >> a few lines after.
> >>
> >> CC: Daniel Mack <zonque@gmail.com>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >
> > Is there a bug that exposed this path?
> 
> Daniel sent a patch recently [1] which makes us call
> for_each_available_child_of_node() on a potentially NULL node
> argument.

And yet in your reply to that patch you argued that the NULL check
should be in the caller!

Anyway, this isn't a big deal. Post a patch fixing both and I'll apply
it.

g.

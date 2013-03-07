Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab3CGMHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:07:32 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:57429 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3CGMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:07:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAGN68GqERhAFbwyBNazDLo4AL_skD6xudwJ=s4t2Y-7c7a1_Gg@mail.gmail.com>
References: <CAGN68GqERhAFbwyBNazDLo4AL_skD6xudwJ=s4t2Y-7c7a1_Gg@mail.gmail.com>
Date: Thu, 7 Mar 2013 13:07:29 +0100
Message-ID: <CACTFLAN_A1k8bA4GWopztCe0sQ6uAE8=iSn2EA2sgaAFi=8-7A@mail.gmail.com>
Subject: Re: Patches
From: Daniel Mack <zonque@gmail.com>
To: Miles Rout <miles.rout@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miles,

On Thu, Mar 7, 2013 at 11:02 AM, Miles Rout <miles.rout@gmail.com> wrote:
> I'm probably stepping on some toes here, but is it really necessary to
> post raw patches to this list? They do rather clog up one's inbox.

It depends what your patches are for. If you're working on a specific
subsystem, it might also suffice sending the patches to the appropriate
mailing list for that subsystem.

Just make sure to always Cc: the maintainers of the bits you're patching,
and check the file MAINTAINERS in your Linux tree. Also read up
Documentation/SubmittingPatches for general information.

> What's wrong with git?

Nothing's wrong with git. It's just that sending patches to a mailing list makes
it easier for people to comment on them.


Daniel

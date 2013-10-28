Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3J1Gfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:35:38 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63582 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3J1Gfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:35:36 -0400
Date: Sun, 27 Oct 2013 23:35:33 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Philippe De Swert <philippe.deswert@jolla.com>
Cc: Philippe De Swert <philippe.deswert@jollamobile.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power:power_supply_syfs : Treat PROP_TYPE as a regular
 attribute first
Message-ID: <20131028063533.GC31266@teo>
References: <1376521798-16985-1-git-send-email-philippe.deswert@jollamobile.com>
 <20131025221504.GA31842@teo>
 <526AF842.4070006@jolla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <526AF842.4070006@jolla.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 02:01:22AM +0300, Philippe De Swert wrote:
...
> I think I did not make myself very clear. Well there are actually no
> different chargers here. It is one USB charger input, however its
> properties are different depending on the actual connected "charger
> device/type". It is the same charging controller however when a usb
> cable is connected and power comes from a PC it is very different
> from when it is a dedicated USB charger.

See this discussion http://lkml.org/lkml/2013/10/28/39, there I am trying
to make a point that we need a separate subsystem for chargers. And in
power supply subsystem we want to only report the AC/USB supply state.

Thanks,

Anton

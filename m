Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaETMXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:23:20 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62225 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750808AbaETMXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:23:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Dudley Du <dudl@cypress.com>, Benson Leung <bleung@google.com>,
        Daniel Kurtz <djkurtz@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] input: cyapa: enable/disable trackpad device based on LID state
Date: Tue, 20 May 2014 14:40:12 +0200
Message-ID: <1507406.BNOsJcxmP9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140520034302.GB986@core.coreip.homeip.net>
References: <77BC725C9062764F874D79F51E1F1A8F40C14099@S04-MBX01-01.s04.local> <20140520034302.GB986@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 19, 2014 08:43:02 PM Dmitry Torokhov wrote:
> Hi Dudley,
> 
> On Wed, Apr 16, 2014 at 08:39:34AM +0000, Dudley Du wrote:
> > Rely on EV_SW and SW_LID bits to identify a LID device, and hook
> > up our filter to listen for SW_LID events to enable/disable touchpad when
> > LID is open/closed.
> > TEST=test on Chomebooks.
> 
> This is a policy and it does not belong in the kernel. Please work with
> Rafael to establish generic interface to put devices into low power mode
> (like accelerating runtime PM idle timeout)

I'm not really sure what you mean here, care to be more specific?

> and use it when userspace detects that lid is closed.

I guess we get an event then, don't we?

Rafael


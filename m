Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3E1TcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:32:25 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:57793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3E1TcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:32:24 -0400
Message-ID: <1369769542.8548.13.camel@jlt4.sipsolutions.net>
Subject: Re: [v3.10-rc2] iwlwifi regression
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 28 May 2013 21:32:22 +0200
In-Reply-To: <CADDKRnBf4i8ZQ4EXC15Sa6z9CZ55w0vBDnXG26sjWgdO9zH45w@mail.gmail.com> (sfid-20130525_111005_833824_A78E43A2)
References: <CADDKRnBf4i8ZQ4EXC15Sa6z9CZ55w0vBDnXG26sjWgdO9zH45w@mail.gmail.com>
	 (sfid-20130525_111005_833824_A78E43A2)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-05-25 at 11:09 +0200, Jörg Otte wrote:
> If iwlwifi/iwldvm are built into the kernel (no loadable modules)
> following error is written to console and syslog since v3.10-rc:
> 
> iwlwifi 0000:08:00.0: failed to load module iwldvm (error -38), is
> dynamic loading enabled?

So you just see the message, the driver actually works? I guess that
makes some sense ... I'll just #ifdef the message.

johannes


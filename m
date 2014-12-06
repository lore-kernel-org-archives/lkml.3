Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaLFP3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:29:04 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:57541 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaLFP3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:29:01 -0500
Date: Sat, 6 Dec 2014 10:28:55 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: Re: Disable input device
Message-ID: <20141206102855.69b4b218@as>
In-Reply-To: <201411291824.03996@pali>
References: <201411291824.03996@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2014 18:24:03 +0100
Pali Rohár <pali.rohar@gmail.com> wrote:

> What do you think about adding new sysfs file "disable" (accept 
> values 1 or 0) for every input device? With "1" it cause that 
> kernel will drop all events from specific input device and if 
> driver provide some function is can be called (e.g. for power 
> management or disabling device at hardware level).
> 

Yeah, I'd like to see this too. I am using xinput to disable the
notebook keyboard so the cats walking across it don't cause any
problems. It would be nice to have a better solution.

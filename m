Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3BYKPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:15:51 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:50663 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab3BYKPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:15:49 -0500
MIME-Version: 1.0
In-Reply-To: <20130220200625.GA1321@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
	<1360334256-22127-4-git-send-email-benjamin.tissoires@gmail.com>
	<20130220200625.GA1321@polaris.bitmath.org>
Date: Mon, 25 Feb 2013 11:15:47 +0100
Message-ID: <CAN+gG=Fy9Be2ebVEB6rGUp8mUsd4ZpRbz6FeAenDh=O+KXEtpA@mail.gmail.com>
Subject: Re: [PATCH 3/7] HID: Kconfig: Remove explicit transport layer dependencies
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Wed, Feb 20, 2013 at 9:06 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> Most HID drivers (rightfully) only depend on the HID bus, not the
>> specific transport layer. Remove such dependencies where applicable.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>
> I suppose you checked this list against newcomers as well, so:
>
>     Acked-by: Henrik Rydberg <rydberg@euromail.se>

I checked, but a newcomer came since: thingM... I'll update the patch
accordingly in the v2.

Cheers,
Benjamin

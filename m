Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab3AVR6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:58:02 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:57366 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3AVR57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:57:59 -0500
MIME-Version: 1.0
In-Reply-To: <1354922656-13506-2-git-send-email-bleung@chromium.org>
References: <1354922656-13506-2-git-send-email-bleung@chromium.org>
Date: Tue, 22 Jan 2013 09:57:54 -0800
Message-ID: <CAD=FV=UORUek34jfH+7mT8o3jDGoaPJkSM5J+BxMCjvtdLY5sw@mail.gmail.com>
Subject: Re: [v3,1/1] Input: add driver for Cypress APA I2C Trackpad
From: Doug Anderson <dianders@chromium.org>
To: Benson Leung <bleung@chromium.org>
Cc: Jean Delvare <khali@linux-fr.org>, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Olof Johansson <olofj@chromium.org>, dudl@cypress.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benson,

On Fri, Dec 7, 2012 at 3:24 PM, Benson Leung <bleung@chromium.org> wrote:
> This patch introduces a driver for Cypress All Points Addressable
> I2C Trackpad, including the ones in 2012 Samsung Chromebooks.

I tried this patch out on my ARM Chromebook running a kernel based on 3.8-rc1
(it has a bunch of other local patches making their way upstream as well).

This patch worked just fine to get the trackpad working.  :)


> This device is compatible with MT protocol type B, providing identifiable
> contacts.
>
> Signed-off-by: Dudley Du <dudl@cypress.com>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Benson Leung <bleung@chromium.org>

Tested-by: Doug Anderson <dianders@chromium.org>

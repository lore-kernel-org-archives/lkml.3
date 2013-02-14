Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527Ab3BNR4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:56:47 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60762 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233Ab3BNR4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:56:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130214171927.GA538@polaris.bitmath.org>
References: <1359673513-22328-1-git-send-email-bleung@chromium.org>
	<1360527340-25936-1-git-send-email-bleung@chromium.org>
	<20130214042635.GC2472@core.coreip.homeip.net>
	<20130214171927.GA538@polaris.bitmath.org>
Date: Thu, 14 Feb 2013 09:56:45 -0800
X-Google-Sender-Auth: _4gOhSAps92JYtc-bEQ-as39Ea8
Message-ID: <CANLzEkvEwqtOYhx7WPoWiq9qm-z9n9dcejp97+PgpPMWs0DKhw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] Input: mouse: cyapa - Add support for cyapa smbus protocol
From: Benson Leung <bleung@chromium.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        khali@linux-fr.org, Olof Johansson <olofj@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>, Dudley Du <dudl@cypress.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks again, Dmitry and Henrik!


On Thu, Feb 14, 2013 at 9:19 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Wed, Feb 13, 2013 at 08:26:35PM -0800, Dmitry Torokhov wrote:
>> On Sun, Feb 10, 2013 at 12:15:40PM -0800, Benson Leung wrote:
>> > This patch adds support for the Cypress APA Smbus Trackpad type,
>> > which uses a modified register map that fits within the
>> > limitations of the smbus protocol.
>> >
>> > Devices that use this protocol include:
>> > CYTRA-116001-00 - Samsung Series 5 550 Chromebook trackpad
>> > CYTRA-103002-00 - Acer C7 Chromebook trackpad
>> > CYTRA-101003-00 - HP Pavilion 14 Chromebook trackpad
>> >
>> > Signed-off-by: Dudley Du <dudl@cypress.com>
>> > Signed-off-by: Benson Leung <bleung@chromium.org>
>> > Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
>> > ---
>> > v2 : Minor style cleanup. Removed unused struct device *dev declarations.
>> > ---
>>
>> Applied, thank you Benson.
>>
>> Henrik, I put you down as "reviewed-by".
>
> Perfect, thank you.
>
> Henrik



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org

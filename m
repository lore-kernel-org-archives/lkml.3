Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3ANJCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:02:19 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:54546 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3ANJCR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Mon, 14 Jan 2013 04:02:17 -0500
Message-Id: <50F3D7A302000078000B531D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 14 Jan 2013 09:02:11 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ondrej Zary" <linux@rainbow-software.org>
Cc: <dmitry.torokhov@gmail.com>, <hpa@linux.intel.com>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>
Subject: Re: your patch "x86, 8042: Enable A20 using KBC to fix S3
 resume on some MSI laptops"
References: <50F3CAFD02000078000B52BE@nat28.tlf.novell.com>
 <201301140929.38462.linux@rainbow-software.org>
 <50F3D1F702000078000B52FB@nat28.tlf.novell.com>
 <201301140954.43795.linux@rainbow-software.org>
In-Reply-To: <201301140954.43795.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.01.13 at 09:54, Ondrej Zary <linux@rainbow-software.org> wrote:
> On Monday 14 January 2013, Jan Beulich wrote:
>> >>> On 14.01.13 at 09:29, Ondrej Zary <linux@rainbow-software.org> wrote:
>> > On Monday 14 January 2013, Jan Beulich wrote:
>> >> Second, considering that enabling A20 (even if just in a fake way),
>> >> is a core system operation, I don't think it belongs into a driver
>> >> that is only optionally present in the kernel.
>> >
>> > The first version of this patch added A20 enabling to early init code.
>> > But that could be dangerous as it was run before any 8042 detection,
>> > possibly breaking systems without 8042. I haven't found a better place
>> > for this.
>>
>> I realize that the change would be more intrusive, but imo that's
>> not an excuse for not doing it properly.
> 
> What's "properly"? Doing extra 8042 detection somewhere else does not look 
> right.

Why?

Jan


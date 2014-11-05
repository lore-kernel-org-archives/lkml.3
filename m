Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaKEXN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:13:29 -0500
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:39026
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbaKEXN2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:13:28 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>
CC: "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] staging: comedi: split bus support into separate
 modules
Thread-Topic: [PATCH 0/5] staging: comedi: split bus support into separate
 modules
Thread-Index: AQHP9TLPK/O0QzpWPkODe23bN/ro9pxKgzsQgAC2MYD//4wE0IAH5g8TgAAFteA=
Date: Wed, 5 Nov 2014 23:13:26 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D88260262E2@P3PWEX4MB008.ex4.secureserver.net>
References: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D882601ABA4@P3PWEX4MB008.ex4.secureserver.net>
 <5454086D.6000401@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D882601B051@P3PWEX4MB008.ex4.secureserver.net>
 <545412F3.60502@mev.co.uk> <545414A6.9090101@mev.co.uk>
 <20141105225049.GA12361@kroah.com>
In-Reply-To: <20141105225049.GA12361@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 05, 2014 3:51 PM, Greg Kroah-Hartman wrote:
> On Fri, Oct 31, 2014 at 11:00:54PM +0000, Ian Abbott wrote:
>> On 31/10/14 22:53, Ian Abbott wrote:
>>> I like the idea of the core comedi module being separated from all the
>>> various buses. And other buses can be added easily without pulling extra
>>> dependencies into the core (e.g. for platform or spi devices).
>> 
>> And if this get's accepted, I'd like to complete the separation by moving
>> the PCI, USB and PCMCIA stuf out of the "comedidev.h" header into their own
>> headers, which obviously means small edits to most of the low-level drivers
>> to #include different headers. (But then, "comedi_pci.h" could #include
>> <linux/pci.h> for example.)
>
> Hartley, any objection to me applying this series?

No objections... Just questions... ;-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Hartley

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbaJaXBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 19:01:00 -0400
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:39425 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757131AbaJaXA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 19:00:59 -0400
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <545414A6.9090101@mev.co.uk>
Date: Fri, 31 Oct 2014 23:00:54 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.1.2
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] staging: comedi: split bus support into separate
 modules
References: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D882601ABA4@P3PWEX4MB008.ex4.secureserver.net> <5454086D.6000401@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D882601B051@P3PWEX4MB008.ex4.secureserver.net> <545412F3.60502@mev.co.uk>
In-Reply-To: <545412F3.60502@mev.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/14 22:53, Ian Abbott wrote:
> I like the idea of the core comedi module being separated from all the
> various buses. And other buses can be added easily without pulling extra
> dependencies into the core (e.g. for platform or spi devices).

And if this get's accepted, I'd like to complete the separation by 
moving the PCI, USB and PCMCIA stuf out of the "comedidev.h" header into 
their own headers, which obviously means small edits to most of the 
low-level drivers to #include different headers. (But then, 
"comedi_pci.h" could #include <linux/pci.h> for example.)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-

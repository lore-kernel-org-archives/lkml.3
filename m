Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3A3LGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:06:10 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:51708 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab3A3LGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:06:07 -0500
Message-ID: <5108FE9B.9000806@mev.co.uk>
Date: Wed, 30 Jan 2013 11:06:03 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Abbott <ian.abbott@mev.co.uk>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        "=?ISO-8859-1?Q?Pete?= =?ISO-8859-1?Q?r_H=FCwe?=" <PeterHuewe@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [Q]staging/comedi: Considation of *_find_boardinfo possible?
References: <201301300041.36064.PeterHuewe@gmx.de> <ADE657CA350FB648AAC2C43247A983F00207A707B3C8@AUSP01VMBX24.collaborationhost.net> <5108FE31.8020107@mev.co.uk>
In-Reply-To: <5108FE31.8020107@mev.co.uk>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-30 11:04, Ian Abbott wrote:
> static int foobar_auto_attach(struct comedi_device *dev,
> 			      unsigned long context_bn)
> {
> 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
> 	struct foobar_board *thisboard = &foobar_boards[bn_foo];

Oops, I meant &foobar_boards[context_bn] there!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

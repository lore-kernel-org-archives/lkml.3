Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbaDVIjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:39:48 -0400
Received: from relay-s04-hub002.domainlocalhost.com ([74.115.207.101]:40386
	"EHLO relay-S04-HUB002.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225AbaDVIjp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:39:45 -0400
From: Dudley Du <dudl@cypress.com>
To: "Dmitry Torokhov (dmitry.torokhov@gmail.com)" 
	<dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "David Solda" <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/6] input: cyapa: integrated with gen5 trackpad
 supported in one driver.
Thread-Topic: [PATCH 0/6] input: cyapa: integrated with gen5 trackpad
 supported in one driver.
Thread-Index: Ac9Xtqv/0ttkMiveQfGJfAU5vYDuVQBl7hWAAS3lD0A=
Date: Tue, 22 Apr 2014 08:39:43 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C153FF@S04-MBX01-01.s04.local>
References: <77BC725C9062764F874D79F51E1F1A8F40C1404A@S04-MBX01-01.s04.local>
In-Reply-To: <77BC725C9062764F874D79F51E1F1A8F40C1404A@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.30.12.150]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Could you help review the patches of input: cyapa for re-architecture and supporting new trackpad devices, I'm really looking forward your responses.

Thanks,
Dudley


> This patch set is made based on kernel 3.14.0. It's aimed to re-architecture the cyapa driver to support the old gen3 trackpad device and new gen5 trackpad device in one cyapa driver for easily products support based on customers' requirements, and add sysfs functions and interfaces supported that required by users and customers.
>
> Beside this patch, it has 6 patches listed as below.
> For these patches each one is patched based on previous one.
>
> patch 1/6: change the architecture of cyapa driver to support function pointers and applying the device proble function in async thread to speed up system boot time.
>
> patch 2/6: add gen5 trackpad devices supported in cyapa driver.
>
> patch 3/6: add full power mode and runtime power mode supported.
>
> patch 4/6: enable/disable trackpad device based on LID state.
>
> patch 5/6: add sysfs interfaces supported for gen3 trackpad device.
>
> patch 6/6: add sysfs interfaces supported for gen5 trackpad device.
This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

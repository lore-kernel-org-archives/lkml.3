Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3LNB6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 20:58:11 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:59734 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab3LNB6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 20:58:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5NjOCqkao03Ea=98gunVEaUUitq8mGLarpKW_DQoDF8g@mail.gmail.com>
References: <529E5C0E.80903@gmail.com>
	<20131212224407.GL4699@google.com>
	<CAE9FiQX8XXkwbhhuNhCF-pHdc_3or_dMEH-VN5NBSEV_eXE-Pg@mail.gmail.com>
	<CAErSpo5BsaLNrny3T1sYknz3wo4hN0SKJk0_u6eNyEd6qq5o=g@mail.gmail.com>
	<428d664592c2466c9e5e6b393df9d690@DM2PR05MB671.namprd05.prod.outlook.com>
	<CAErSpo5NjOCqkao03Ea=98gunVEaUUitq8mGLarpKW_DQoDF8g@mail.gmail.com>
Date: Fri, 13 Dec 2013 17:58:08 -0800
X-Google-Sender-Auth: -Ld7tu5IQQf3FfSmuPZkP-r3Sn0
Message-ID: <CAE9FiQX-ZP0R-weuPoOJ6GkPxOLp5jk9thnjfPQ+Q5tCHugD4w@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] pciehp: Use link change notifications for hot-plug
 and removal
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatjain@juniper.net>, Rajat Jain <rajatjain.linux@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        Rajat Jain <rajatxjain@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 1:14 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Dec 13, 2013 at 12:04 PM, Rajat Jain <rajatjain@juniper.net> wrote:
>
>> Once again: the way I interpret this is:
>> * Always enable Link events.
>> * Disable presence events if attention button is present.
>
> That sounds like a good plan to me.

How about Diag_Reset from MPT2SAS and others?
link could up and down

Yinghai

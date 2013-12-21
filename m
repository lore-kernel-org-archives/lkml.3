Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3LUXQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 18:16:49 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:45668 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755141Ab3LUXQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 18:16:47 -0500
MIME-Version: 1.0
In-Reply-To: <20131221210638.GA30102@kroah.com>
References: <1387594651-25771-1-git-send-email-rapatel@apm.com>
	<20131221210638.GA30102@kroah.com>
Date: Sat, 21 Dec 2013 15:16:45 -0800
Message-ID: <CAN1v_PuttE1z2sLvscdLZLjpKFexGJeJm_1xxT7UatGeuM65Pw@mail.gmail.com>
Subject: Re: [PATCH V2 0/4] misc: xgene: Add support for APM X-Gene SoC Queue
 Manager/Traffic Manager
From: Ravi Patel <rapatel@apm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
        "patches@apm.com" <patches@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 1:06 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Dec 20, 2013 at 06:57:27PM -0800, Ravi Patel wrote:
>> This patch adds support for APM X-Gene SoC Queue Manager/Traffic Manager.
>>  QMTM is required by APM X-Gene SoC Ethernet, PktDMA (XOR Engine) and
>>  Security Engine subsystems. All subsystems communicate with QMTM using
>>  messages which include information about the work to be performed and
>>  the location of associated data buffers.
>
> As you failed to respond or even acknowledge any of my review comments
> before, I don't understand what you expect me to do with this patch dump
> again.
>
> Remember, kernel development is about trust.  You need me to trust that
> you know what you are doing, and will be able to handle feedback and
> respond to issues that come up over time.  Right now that trust is in
> the negative zone, around "general annoyance" levels.  It's up to you to
> change that or not, just like it is up to me to take your code, or not.
>
> grumble,
>
> greg k-h

Greg,

I apologize for not responding to your comments before sending patch v2
The main intention of sending patch v2 was to remove APM confidential notice,
which was present in the first QMTM patch.
I wanted to send out patch v2 quickly, so that community can start reviewing
 the QMTM code.

I will go through all your comments and respond it.

pardon,

Ravi

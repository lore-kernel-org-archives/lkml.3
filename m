Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaCCUmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:42:46 -0500
Received: from forward16.mail.yandex.net ([95.108.253.141]:41571 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbaCCUmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:42:44 -0500
From: zbr@ioremap.net
Envelope-From: drustafa@yandex.ru
To: David Miller <davem@davemloft.net>,
        "khoroshilov@ispras.ru" <khoroshilov@ispras.ru>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140303.153945.218115412923126825.davem@davemloft.net>
References: <1393704056-13943-1-git-send-email-khoroshilov@ispras.ru> <20140303.153945.218115412923126825.davem@davemloft.net>
Subject: Re: [PATCH] connector: remove duplicated code in cn_call_callback()
MIME-Version: 1.0
Message-Id: <181701393879360@web25g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 04 Mar 2014 00:42:40 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone

04.03.2014, 00:39, "David Miller" <davem@davemloft.net>:
> From: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Date: Sun, š2 Mar 2014 00:00:56 +0400
>
>> šThere were a couple of patches fixing the same bug that
>> šresults in duplicated err = 0; assignment.
>> šThe patch removes one of them.
>>
>> šSigned-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>
> Applied to net-next, thank you.

Thank you

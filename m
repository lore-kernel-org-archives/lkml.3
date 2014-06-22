Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaFVK4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 06:56:50 -0400
Received: from shell.v3.sk ([195.168.3.45]:51084 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaFVK4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 06:56:47 -0400
Message-ID: <1403434599.532.4.camel@goatlord.localdomain>
Subject: Re: [PATCHv7 2/5] mailbox: Introduce framework for mailbox
From: Lubomir Rintel <lkundrak@v3.sk>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Jun 2014 12:56:39 +0200
In-Reply-To: <1402592479-7244-1-git-send-email-jaswinder.singh@linaro.org>
References: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
	 <1402592479-7244-1-git-send-email-jaswinder.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.3 (3.12.3-2.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 22:31 +0530, Jassi Brar wrote:
> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
> 
> Client driver developers should have a look at
>  include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h
...
> +struct mbox_chan *mbox_request_channel(const struct mbox_client *cl)
> +{
...
> +	chan->cl = cl;

drivers/mailbox/mailbox.c: In function ‘mbox_request_channel’:
drivers/mailbox/mailbox.c:361:11: warning: assignment discards ‘const’
qualifier from pointer target type [enabled by default]
  chan->cl = cl;



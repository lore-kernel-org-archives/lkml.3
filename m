Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643AbaCTTzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:55:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:45252 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaCTTzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:55:32 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Tull <atull@altera.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dinh Nguyen <dinguyen@altera.com>
Subject: two patches for the synposys gpio controller
Date: Thu, 20 Mar 2014 20:55:21 +0100
Message-Id: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I didn't manage to fully test this yet therefore they go out as RFC. The
list corruption I refer to in irq_setup_generic_chip() real, this is gone.
What I am not sure yet is if the interrupt functionally is still there…

Sebastian


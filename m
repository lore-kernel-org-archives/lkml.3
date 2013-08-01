Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3HATpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:45:21 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52739 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab3HATpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:45:19 -0400
Date: Thu, 1 Aug 2013 20:45:14 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: How to use GPIO triggers?
Message-ID: <20130801194513.GA32079@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've tried googling again and again.

But I can't seem to find out how to use GPIO triggers with the ADC driver.

I am using a patched am335x driver and kernel version 3.11.
I can use sysfs triggers to trigger and read a buffer of samples easily.

But I cannot figure out how to connect a gpio to trigger the driver.
Is it some additional support to add to the driver?

Or am I missing something very obvious..

Can someone spare a few minutes and point me in the right direction?

Thank-you
Zubair Lutfullah

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423528Ab3CVWfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:35:13 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:33799 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423429Ab3CVWfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:35:11 -0400
Message-ID: <514CDC9B.1050503@gmail.com>
Date: Fri, 22 Mar 2013 23:35:07 +0100
From: Sergio Callegari <sergio.callegari@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel panic on stable kernel 3.8.2 when closing bluetooth dun
 connection
References: <51498CFE.9060804@gmail.com> <20130320161712.GA27840@kroah.com>
In-Reply-To: <20130320161712.GA27840@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the end it may not be caused by bluetooth, but by ppp.

Found bug reports on ubuntu indicating that 3.8.x panic on ppp disconnection.
Unfortunately, I cannot try without bluetooth with my configuration.
(when wired, phone does not use ppp, but appears as a wired network interface).

Sergio

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3IZLZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:25:43 -0400
Received: from nucleo.com.es ([46.163.75.183]:36269 "EHLO nucleo.com.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446Ab3IZLZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:25:42 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Sep 2013 07:25:42 EDT
Message-ID: <5243E012.7040200@vonmankowski.de>
Date: Thu, 26 Sep 2013 09:19:46 +0200
From: Alejandro von Mankowski <alejandro@vonmankowski.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM intel TX300AC
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since Kernel Version 3.10.0-031000 (including the newest 3.11.1 and
3.12.0 rc1) my Laptop Screen doesn't work anymore. The backlight is on but
the screen keeps black. In Version 3.9.11 it still works perfect.

My Laptop is a TX300AC. My system is

ubuntu 13.04

/proc/cpuinfo http://pastebin.com/fEUfzpkP
lspci -vvv http://pastebin.com/BUs3YMJQ

Best regards,
Alejandro

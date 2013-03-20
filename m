Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab3CTKSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:18:49 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63219 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3CTKSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:18:46 -0400
Message-ID: <51498CFE.9060804@gmail.com>
Date: Wed, 20 Mar 2013 11:18:38 +0100
From: Sergio Callegari <sergio.callegari@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Kernel panic on stable kernel 3.8.2 when closing bluetooth dun connection
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is just a short note to let you know that 3.8.2 panics on closing a 
bluetooth dun connection.

This is seen with the ubuntu mainline kernel 3.8.2 that should be a vanilla 
stable kernel.

Observed on a DELL E6500 which has BCM2046 Bluetooth while connecting to the
internet using a Samsung Galaxy S mobile phone via bluetooth DUN through the 
network manager.  When network manager is asked to close the connection, the 
kernel panics, the system drops out of Xorg, shows for a couple of seconds a 
long log including the words 'panic' and 'not synching', the numlock, caps-lock 
keys start flashing and the system freezes.

It is 100% repeatable.

The ubuntu kernel, that is a 3.5.0 plus ubuntu tweaks, backports, etc does not 
panic.

Thanks for the attention and best regards,

Sergio Callegari

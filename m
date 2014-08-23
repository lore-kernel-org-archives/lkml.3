Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaHWJbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 05:31:44 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63185 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaHWJbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 05:31:43 -0400
MIME-Version: 1.0
Date: Sat, 23 Aug 2014 11:31:41 +0200
Message-ID: <CALU-w9-ZjjnrYW5HxRCe-HGZWSK0JMwNU_zcSbKXM4JgGyLdbw@mail.gmail.com>
Subject: Problem with commit: x86, iosf: Make IOSF driver modular and usable
 by more drivers
From: =?UTF-8?Q?Fejes_J=C3=B3zsef?= <jozsef.fejes@gmail.com>
To: linux-kernel@vger.kernel.org, linux-stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think there's a problem with commit
6b8f0c8780c71d78624f736d7849645b64cc88b7: config IOSF_MBI is
automatically a module and I cannot change that.

I've been using 3.15.* stable kernels. I have module support enabled,
but I build everything into the kernel, so I don't actually have any
modules built. I just upgraded to 3.16.1, and found out that I now
have this one module. I cannot find it in the menu, so I edited the
.config file by hand, but it changes back from =y to =m. Could you
please look into fixing it, and push it to 3.16.* stable branch?

Best regards,
Jozsef

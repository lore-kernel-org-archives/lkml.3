Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab3HHGDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:03:46 -0400
Received: from mail-la0-f66.google.com ([209.85.215.66]:40602 "EHLO
	mail-la0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab3HHGDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:03:45 -0400
MIME-Version: 1.0
Date: Thu, 8 Aug 2013 11:33:43 +0530
Message-ID: <CAEtk5gcFrnbgGNeAU45-6TKR=m6=9QorFj_j_RX+ufGBfs5TuQ@mail.gmail.com>
Subject: Linux apanic mechanism and difference from newer ram_console/persistent_ram
 mechanism
From: Vijay <thelonejoker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am new to the Kernel-Mailing list. I am not subscribed at the moment
and would really appreciate it, if I can be CC'd in the
reply/responses for my question.

I am studying the different logging mechanisms on Linux in case of a
Kernel panic (OOPS). So far from  my search on the web, I have been
able to derive the following information, please correct me if wrong:

- apanic was an old mechanism of getting the job done.
- ram_console/persistent_ram is a new mechanism.

Could someone enlighten me about the following in this regard ?

- What was the old apanic mechanism, at a high-level how did this work ?

- Why was the apanic mechanism deprecated, in favor of the
ram_console/persistent_ram mechanism ?

- What advantages does the new ram_console/persistent_ram mechinsm
bring to the table.

- In what way is the ram_console/persistent_ram functionally different
from the old apanic approach ?

I am just looking for pointers and high level answers, in some sense a
direction which I can take to research the mechanisms further. I would
appreciate any relevant information in this regard.

Thanks

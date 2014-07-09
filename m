Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaGICW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:22:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43695 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGICWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:22:24 -0400
MIME-Version: 1.0
Date: Tue, 8 Jul 2014 22:22:23 -0400
Message-ID: <CAPDOMVhZr=rP_7Bsez==4LzScZxsQnfpaiYpvGRuHCf9WnqHTw@mail.gmail.com>
Subject: TIckless Timers On Laptops and Battery Enabled Devices
From: Nick Krause <xerofoify@gmail.com>
To: fweisbec@gmail.com
Cc: josh@joshtriplett.org, khilman@linaro.org, paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I  am been thinking , this is just a idea but can we enable the kernel
to be tick less for laptops when they are on battery. I don't have any
laptop on me to test but if
someone can test the battery on a tick less kernel versus non tick
less to see if it increases battery. It would be good if we can test
when it's in standby , high cpu usage
and average work to see if it's a good idea to enable a tick less
kernel for default when a user is on battery for laptops and perhaps
even get into the embedded boards
that run on battery and/or cellphones if it's a great help in
increasing  battery. I will also be glad to help these features into
the mainline kernel if they are of use to saving
battery.
Cheers Nick

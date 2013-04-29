Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3D2LeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:34:21 -0400
Received: from plane.gmane.org ([80.91.229.3]:60653 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab3D2LeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:34:19 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "lkml@tigusoft.pl" <lkml@tigusoft.pl>
Subject: debugging live kernel
Date: Mon, 29 Apr 2013 13:34:08 +0200
Organization: tigusoft.pl
Message-ID: <klllre$plq$1@ger.gmane.org>
Reply-To: lkml@tigusoft.pl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bolobolo2.torservers.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if my currently running kernel starts to do strange things and I
suspect it might have bug or was corrupted, what steps can be taken to
check for more info, other then dmesg?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab3CZRkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:40:20 -0400
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:42905 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951Ab3CZRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:40:14 -0400
X-Greylist: delayed 4654 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Mar 2013 13:40:14 EDT
Date: Tue, 26 Mar 2013 16:22:28 +0000
From: Mike Keehan <mike@keehan.net>
To: linux-kernel@vger.kernel.org
Subject: Git bisect problem
Message-ID: <20130326162228.288994ef@laptop3>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to find out which update causes my 5G Wifi
connection to time out when authenticating.

Following the instructions in git help bisect, I
git cloned the kernel, then git bisect start, and
git bisect bad v3.9.0-rc2.

This errors with :-
  fatal: Needed a single revision
  Bad rev input: v3.9.0-rc2

and git bisect good v3.9.0-rc1 gives same error.

How are you supposed to specify the revision?

Regards,

  Mike.

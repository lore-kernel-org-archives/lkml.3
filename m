Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaANMXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:23:47 -0500
Received: from 82-68-191-81.dsl.posilan.com ([82.68.191.81]:57703 "EHLO
	rainbowdash.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751287AbaANMXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:23:45 -0500
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RESEND] v2: clock_ops.c fixes
Date: Tue, 14 Jan 2014 12:23:39 +0000
Message-Id: <1389702222-17260-1-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A re-send of the clk_ops.c fixes for handling clocks with the
current renesas development branch. I am not sure if these need
to be applied to any stable kernel branches.

>From v1:
- Fixed comments from Rafael Wysocki on checking of ret.


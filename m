Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbaHHDFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 23:05:49 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:38580 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaHHDFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 23:05:40 -0400
From: =?utf-8?B?56mN5Li55bC8?= Dan Jacobson <jidanni@jidanni.org>
To: linux-kernel@vger.kernel.org
Subject: disable "Call Trace:"
Date: Fri, 08 Aug 2014 11:05:26 +0800
Message-ID: <877g2jznnt.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idea: if the user could disable
the "Call Trace:"
seen upon "Kernel panic - not syncing: attempted to kill init!"
he would then be able to see more lines above without having it shoved
off the screen with the useless (to him) call trace.

e.g., using panic=222 call_trace=disabled would give him enough time and room
to read more of what happened from the screen.

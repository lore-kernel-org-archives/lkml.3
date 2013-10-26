Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3JZCFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 22:05:31 -0400
Received: from mailserver01.multibase.pt ([80.172.224.63]:58511 "EHLO
	mailserver01.multibase.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3JZCFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 22:05:30 -0400
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Oct 2013 22:05:30 EDT
Date: Sat, 26 Oct 2013 02:55:04 +0100 (WEST)
From: Gustavo Homem <gustavo@angulosolido.pt>
To: linux-kernel@vger.kernel.org
Subject: CONFIG_FAIR_USER_SCHED oficial replacement
Message-ID: <650686eb-3310-41cd-9547-b4604ef78380@mailserver01.multibase.pt>
In-Reply-To: <4fe6af83-0c8b-41d7-87b5-2beee3402632@mailserver01.multibase.pt>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [95.136.63.19]
X-Mailer: Zimbra 7.1.1_GA_3196 (ZimbraWebClient - FF3.0 (Linux)/7.1.1_GA_3196)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been reading documentation on fair share scheduling and apparently the CONFIG_FAIR_USER_SCHED option has been removed from the kernel. If I understood correctly the use of this option would automatically enable per user fair share scheduling, with each user's processes falling directly into the right schedule group.

Question: what is currently the recommended way of achieving the same effect? I understand that there is a general approach for task groups, but on a multi-user environment with a varying number of users it is not clear to me what is the preferred method for automatically creating and removing the groups and distributing the processes to each group.

Best regards
Gustavo

-- 
Angulo Sólido - Tecnologias de Informação
http://angulosolido.pt

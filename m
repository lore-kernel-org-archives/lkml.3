Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab3GTIjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:39:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44622 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3GTIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:39:28 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/12] apparmor: add policy interface and convert to RCU
Date: Sat, 20 Jul 2013 01:38:35 -0700
Message-Id: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches expands the apparmorfs policy interface by allowing
multiple profiles to loaded as an atomic set and an introspection interface
to apparmor, allowing currently loaded policy to be listed and introspected
from userspace.                                                                

The profile lists where converted to RCU so improve performance but to also
keep profile load, and interface file creation from being able to block
policy lookups in enforcement code.



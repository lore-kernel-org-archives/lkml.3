Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3AQND7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:03:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316Ab3AQND6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:03:58 -0500
From: =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>
To: linux-kernel@vger.kernel.org
Subject: RFC: allow empty symlink targets
Date: Thu, 17 Jan 2013 13:03:52 +0000
Message-Id: <1358427833-3847-1-git-send-email-P@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The discussion leading to this is at http://bugs.gnu.org/13447
In summary other systems allow an empty target for a symlink,
and POSIX specifies that it should be allowed?

thanks,
Pádraig.


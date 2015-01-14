Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbbANQ5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:57:49 -0500
Received: from mx02.posteo.de ([89.146.194.165]:40890 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbbANQ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:57:48 -0500
From: Martin Kepplinger <martink@posteo.de>
To: mingo@kernel.org
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com, tytso@mit.edu,
        maxime.coquelin@st.com, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] Example changes using proposed sign_extend functions
Date: Wed, 14 Jan 2015 17:56:37 +0100
Message-Id: <1421254601-7242-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421083370-24924-1-git-send-email-martink@posteo.de>
References: <1421083370-24924-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are 4 of probably many examples of what could be changed if the proposed
sign_extend8, 16 and 64 are added to bitops.h, now as real patches.

Again, keep in mind, only take them if "PATCH v2 add sign_exted8, 16 and 64"
is included first.

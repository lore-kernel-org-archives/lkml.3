Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbbATMbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:31:32 -0500
Received: from mx02.posteo.de ([89.146.194.165]:55377 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbbATMba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:31:30 -0500
From: Martin Kepplinger <martink@posteo.de>
To: torvalds@linux-foundation.org, jsrhbz@kanargh.force9.co.uk,
        christoph.muellner@theobroma-systems.com, linux@roeck-us.net,
        linux@rasmusvillemoes.dk, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@kernel.org, akpm@linux-foundation.org,
        hpa@zytor.com, maxime.coquelin@st.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tytso@mit.edu
Cc: linux-tip-commits@vger.kernel.org
Subject: [PATCH v3 0/2] bitops.h: add sign_extend64() API and improve doc
Date: Tue, 20 Jan 2015 13:30:53 +0100
Message-Id: <1421757055-8234-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <CA+55aFycO_d0oO9rw9fXa13NSNc0Am8v+3rV+eSH9YdsCi-2Mg@mail.gmail.com>
References: <CA+55aFycO_d0oO9rw9fXa13NSNc0Am8v+3rV+eSH9YdsCi-2Mg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for reviewing. I propose the following additions instead.

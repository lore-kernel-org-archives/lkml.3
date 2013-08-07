Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab3HGSQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:16:43 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:44542 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932258Ab3HGSQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:16:42 -0400
Date: Wed, 7 Aug 2013 18:16:40 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 1/2] mm: make vmstat_update periodic run conditional
In-Reply-To: <0000013f61e7609b-a8d1907b-8169-4f77-ab83-a624a8d0ab4a-000000@email.amazonses.com>
Message-ID: <0000014059feb970-d3c945ce-da75-4a07-a8bc-eabbf54702d2-000000@email.amazonses.com>
References: <CAOtvUMc5w3zNe8ed6qX0OOM__3F_hOTqvFa1AkdXF0PHvzGZqg@mail.gmail.com> <1371672168-9869-1-git-send-email-gilad@benyossef.com> <0000013f61e7609b-a8d1907b-8169-4f77-ab83-a624a8d0ab4a-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.07-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any work in progress on this issue?

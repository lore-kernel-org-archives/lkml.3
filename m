Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3ARNzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:55:49 -0500
Received: from mx0.aculab.com ([213.249.233.131]:46532 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754515Ab3ARNzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:55:47 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch v2] b43: N-PHY: fix gain in b43_nphy_get_gain_ctl_workaround_ent()
Date: Fri, 18 Jan 2013 13:53:43 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7118@saturn3.aculab.com>
In-Reply-To: <20130118133658.GA31186@elgon.mountain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch v2] b43: N-PHY: fix gain in b43_nphy_get_gain_ctl_workaround_ent()
Thread-Index: Ac31gNQDU9CDo55gQGqo7ruDMOo6HQAAlECw
References: <50F84AF3.5070901@bfs.de> <20130118133658.GA31186@elgon.mountain>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Stefano Brivio" <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		int gain_data[] = {0x0062, 0x0064, 0x006a, 0x106a, 0x106c,
> +				   0x1074, 0x107c, 0x207c};

static const int ...

	David




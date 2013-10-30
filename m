Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3J3OMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:12:14 -0400
Received: from mx0.aculab.com ([213.249.233.131]:51739 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753225Ab3J3OMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:12:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH net-next 1/5] lib: crc32: clean up spacing in test cases
Date: Wed, 30 Oct 2013 14:10:05 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B73C8@saturn3.aculab.com>
In-Reply-To: <1383141418.12439.76.camel@joe-AO722>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH net-next 1/5] lib: crc32: clean up spacing in test cases
Thread-Index: Ac7Vd7OdMOj2yA17SKWabg/0m71rfQAAaG2Q
References: <1383130252-1515-1-git-send-email-dborkman@redhat.com> <1383130252-1515-2-git-send-email-dborkman@redhat.com> <1383141418.12439.76.camel@joe-AO722>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Joe Perches" <joe@perches.com>, "Daniel Borkmann" <dborkman@redhat.com>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-sctp@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	{0x674bf11d, 0x00000038, 0x00000542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
>
> these could be
> 
> +	{0x674bf11d, 0x38, 0x542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},

Or even:
#define X(a, b, c, d, e, f) {0x##a, 0x##b, 0x##c, 0x##d, 0x##e. 0x##f}
	X(674bf11d, 38, 542, 0af6d466, d8b6e4c1, f6e93d6c),
...
#undef X

	David




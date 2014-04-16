Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161106AbaDPSy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:54:26 -0400
Received: from 69-178-150-48.static-ip.telepacific.net ([69.178.150.48]:31380
	"EHLO ImsEx1.ims.dom" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754972AbaDPSyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:54:22 -0400
From: Chris Healy <chealy@imsco-us.com>
To: Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/3] net: mdio-gpio: Use devm_ functions where possible
Thread-Topic: [PATCH 1/3] net: mdio-gpio: Use devm_ functions where possible
Thread-Index: AQHPWRnmnQMOuc4HVEy6zp5aFN820psUlmQqgAAA44o=
Date: Wed, 16 Apr 2014 18:50:56 +0000
Message-ID: <724F6C6CDC8C86478473775085778C4E09E86BE0@ImsEx1.ims.dom>
References: <1397614602-29694-1-git-send-email-linux@roeck-us.net>,<1397614602-29694-2-git-send-email-linux@roeck-us.net>,<724F6C6CDC8C86478473775085778C4E09E86BC3@ImsEx1.ims.dom>
In-Reply-To: <724F6C6CDC8C86478473775085778C4E09E86BC3@ImsEx1.ims.dom>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [11.32.30.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I just sent it.  Hopefully, I didn't mess it up again!

Do I need to do the same for 2/3 and 3/3?
________________________________________
From: Chris Healy
Sent: Wednesday, April 16, 2014 11:48 AM
To: Guenter Roeck; Florian Fainelli
Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org
Subject: RE: [PATCH 1/3] net: mdio-gpio: Use devm_ functions where possible

On Tue, Apr 15, 2014 at 07:16:40PM -0700, Guenter Roeck wrote:
> This simplifies error path and deinit/removal functions.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Tested-by: Chris Healy <cphealy@gmail.com>

________________________________


This email and any files transmitted with it are confidential & proprietary to Systems and Software Enterprises, LLC. This information is intended solely for the use of the individual or entity to which it is addressed. Access or transmittal of the information contained in this e-mail, in full or in part, to any other organization or persons is not authorized.

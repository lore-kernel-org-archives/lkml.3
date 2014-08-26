Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366AbaHZM66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:58:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52130 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbaHZM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:58:57 -0400
X-AuditID: cbfee68e-f79536d000000fd1-f8-53fc848f0384
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 06/18] backlight: cr_bllcd: add blank line after declarations
Date: Tue, 26 Aug 2014 21:58:55 +0900
Message-id: <00b001cfc12d$7e7ddaa0$7b798fe0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAEu3Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI93+lj/BBm8arSyO7pzIZHF54SVW
	i/tfjzJaXN41h82BxWPnrLvsHneu7WHz6NuyitHj8ya5AJYoLpuU1JzMstQifbsErowPM46y
	F+xjq3j/+B9zA+MZ1i5GTg4JAROJcws3sUHYYhIX7q0Hsrk4hASWMUos/tzDBlP0sukaK0Ri
	OqNE74wmRgjnN6PExYk/warYBNQkvnw5zA5iiwgoSGzufQa2glkgV+L3zJWMILaQgK3E/G0r
	wOKcAnYSSw+fA6sXFvCVmPegjamLkYODRUBVYso0DZAwL1D5kv272CFsQYkfk++xQIzUkli/
	8zgThC0vsXnNW2aQVgkBdYlHf3UhLjCSmPFtFjtEiYjEvhfvwE6WEDjFLrHo7EqwE1gEBCS+
	TT7EAtErK7HpADPEv5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpRcZ6RUn
	5haX5qXrJefnbmKERGXfDsabB6wPMQpwMCrx8N6I/x0sxJpYVlyZe4jRFOiiicxSosn5wNjP
	K4k3NDYzsjA1MTU2Mrc0UxLnTZD6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0d/10iR9
	/mtTODZOrvMIdlG9xnr20KPzr23Wme7aP8Fu9cvkoCerbshHn5+zxCQ0KOtLzjq+z0svnTEp
	zjrTIJcWuTU1RJ+5qr5R9F9gdr3V5z+nEq9dkpty7tXLn9HLm18f7bjmcX3lAhVeP4utokv5
	riWlaYb/lxeaKJQcWW+Qb3qQpemfjRJLcUaioRZzUXEiAHnTQIbFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd3+lj/BBo3nzCyO7pzIZHF54SVW
	i/tfjzJaXN41h82BxWPnrLvsHneu7WHz6NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMDzOOshfsY6t4//gfcwPjGdYuRk4OCQETiZdN16BsMYkL99az
	dTFycQgJTGeU6J3RxAjh/GaUuDjxJxtIFZuAmsSXL4fZQWwRAQWJzb3PwLqZBXIlfs9cyQhi
	CwnYSszftgIszilgJ7H08DmwemEBX4l5D9qYuhg5OFgEVCWmTNMACfMClS/Zv4sdwhaU+DH5
	HgvESC2J9TuPM0HY8hKb17xlBmmVEFCXePRXF+ICI4kZ32axQ5SISOx78Y5xAqPQLCSTZiGZ
	NAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI75Z1I7GFc2WBxiFOBgVOLh
	vRH/O1iINbGsuDL3EKMEB7OSCO+PpD/BQrwpiZVVqUX58UWlOanFhxhNgf6cyCwlmpwPTEd5
	JfGGxiZmRpZGZhZGJubmSuK8B1qtA4UE0hNLUrNTUwtSi2D6mDg4pRoYXcv3lKTML5n0Jqdv
	ycnfXxYv6JjF6bK887V137yq/m+fW9ZXfL0rwfmrKbbzzhuRzw9ZD97leJviZHCPI/jWYt3C
	k/knVsndmpG79o2h8B6/bXfirHWbE6xtX6b+SWN1X5a9pqAp5PamO9ULas0rxJYsMI7YIxDy
	rPb/hWKFGzsVpqt93nfSTImlOCPRUIu5qDgRAMuD3UUPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: Missing a blank line after declarations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/cr_bllcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index f3fed9ef745f..3e3880fc8c8e 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -235,6 +235,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 static int cr_backlight_remove(struct platform_device *pdev)
 {
 	struct cr_panel *crp = platform_get_drvdata(pdev);
+
 	crp->cr_backlight_device->props.power = FB_BLANK_POWERDOWN;
 	crp->cr_backlight_device->props.brightness = 0;
 	crp->cr_backlight_device->props.max_brightness = 0;
-- 
2.0.0



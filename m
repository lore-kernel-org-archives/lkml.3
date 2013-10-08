Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3JHXBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:01:46 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:50612 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755525Ab3JHXBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:01:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:4:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2393:2559:2562:2640:2828:2896:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:4250:4321:4605:5007:6119:7652:7875:7903:7904:8603:8957:9040:10004:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12679:13141:13161:13229:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sink46_2b77f9bfad326
X-Filterd-Recvd-Size: 15509
Message-ID: <1381273297.23937.5.camel@joe-AO722>
Subject: [Trivial PATCH] usb: Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 16:01:37 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These aren't necessary after switch and if blocks.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/core/hcd.c              | 2 +-
 drivers/usb/core/hub.c              | 2 +-
 drivers/usb/dwc3/ep0.c              | 6 +++---
 drivers/usb/gadget/composite.c      | 2 +-
 drivers/usb/gadget/dummy_hcd.c      | 6 +++---
 drivers/usb/gadget/goku_udc.c       | 2 +-
 drivers/usb/gadget/net2280.c        | 4 ++--
 drivers/usb/gadget/rndis.c          | 2 +-
 drivers/usb/gadget/tcm_usb_gadget.c | 4 ++--
 drivers/usb/host/ehci-dbg.c         | 2 +-
 drivers/usb/host/fotg210-hcd.c      | 2 +-
 drivers/usb/host/fusbh200-hcd.c     | 2 +-
 drivers/usb/host/isp1362-hcd.c      | 2 +-
 drivers/usb/host/ohci-dbg.c         | 2 +-
 drivers/usb/host/sl811-hcd.c        | 4 ++--
 drivers/usb/host/uhci-pci.c         | 2 +-
 drivers/usb/host/whci/hcd.c         | 4 ++--
 drivers/usb/musb/musb_core.c        | 2 +-
 drivers/usb/musb/musb_dsps.c        | 2 +-
 drivers/usb/musb/musb_gadget.c      | 2 +-
 drivers/usb/musb/musb_host.c        | 2 +-
 drivers/usb/phy/phy-twl4030-usb.c   | 2 +-
 drivers/usb/phy/phy-ulpi-viewport.c | 2 +-
 drivers/usb/wusbcore/cbaf.c         | 4 ++--
 drivers/usb/wusbcore/devconnect.c   | 2 +-
 drivers/usb/wusbcore/wa-xfer.c      | 4 ++--
 26 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index d6a8d23..b915cac 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1813,7 +1813,7 @@ rescan:
 					s = "-intr"; break;
 				 default:
 			 		s = "-iso"; break;
-				};
+				}
 				s;
 			}));
 		usb_put_urb (urb);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index e6b682c..c95e2fc 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -433,7 +433,7 @@ static void set_port_led(
 			case HUB_LED_OFF: s = "off"; break;
 			case HUB_LED_AUTO: s = "auto"; break;
 			default: s = "??"; break;
-			}; s; }),
+			} s; }),
 			status);
 }
 
diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 7fa93f4..95f7649 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -352,7 +352,7 @@ static int dwc3_ep0_handle_status(struct dwc3 *dwc,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	response_pkt = (__le16 *) dwc->setup_buf;
 	*response_pkt = cpu_to_le16(usb_status);
@@ -470,7 +470,7 @@ static int dwc3_ep0_handle_feature(struct dwc3 *dwc,
 
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
@@ -709,7 +709,7 @@ static int dwc3_ep0_std_request(struct dwc3 *dwc, struct usb_ctrlrequest *ctrl)
 		dev_vdbg(dwc->dev, "Forwarding to gadget driver\n");
 		ret = dwc3_ep0_delegate_req(dwc, ctrl);
 		break;
-	};
+	}
 
 	return ret;
 }
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index d4f0f33..3e7ae70 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -354,7 +354,7 @@ static u8 encode_bMaxPower(enum usb_device_speed speed,
 		return DIV_ROUND_UP(val, 8);
 	default:
 		return DIV_ROUND_UP(val, 2);
-	};
+	}
 }
 
 static int config_buf(struct usb_configuration *config,
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index b8a2376..8f4dae3 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -544,7 +544,7 @@ static int dummy_enable(struct usb_ep *_ep,
 		 default:
 			 val = "ctrl";
 			 break;
-		 }; val; }),
+		 } val; }),
 		max, ep->stream_en ? "enabled" : "disabled");
 
 	/* at this point real hardware should be NAKing transfers
@@ -2271,7 +2271,7 @@ static inline ssize_t show_urb(char *buf, size_t size, struct urb *urb)
 		default:
 			s = "?";
 			break;
-		 }; s; }),
+		 } s; }),
 		ep, ep ? (usb_pipein(urb->pipe) ? "in" : "out") : "",
 		({ char *s; \
 		switch (usb_pipetype(urb->pipe)) { \
@@ -2287,7 +2287,7 @@ static inline ssize_t show_urb(char *buf, size_t size, struct urb *urb)
 		default: \
 			s = "-iso"; \
 			break; \
-		}; s; }),
+		} s; }),
 		urb->actual_length, urb->transfer_buffer_length);
 }
 
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index c64deb9..ef7ba00 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1165,7 +1165,7 @@ static int udc_proc_read(struct seq_file *m, void *v)
 				s = "invalid"; break;
 			default:
 				s = "?"; break;
-			}; s; }),
+			} s; }),
 			(tmp & EPxSTATUS_TOGGLE) ? "data1" : "data0",
 			(tmp & EPxSTATUS_SUSPEND) ? " suspend" : "",
 			(tmp & EPxSTATUS_FIFO_DISABLE) ? " disable" : "",
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 0781bff..80d527f 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -129,7 +129,7 @@ static char *type_string (u8 bmAttributes)
 	case USB_ENDPOINT_XFER_BULK:	return "bulk";
 	case USB_ENDPOINT_XFER_ISOC:	return "iso";
 	case USB_ENDPOINT_XFER_INT:	return "intr";
-	};
+	}
 	return "control";
 }
 #endif
@@ -1630,7 +1630,7 @@ static ssize_t queues_show(struct device *_dev, struct device_attribute *attr,
 					val = "intr"; break;
 				 default:
 					val = "iso"; break;
-				 }; val; }),
+				 } val; }),
 				usb_endpoint_maxp (d) & 0x1fff,
 				ep->dma ? "dma" : "pio", ep->fifo_size
 				);
diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index 9575085..a3ad732 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -1068,7 +1068,7 @@ static int rndis_proc_show(struct seq_file *m, void *v)
 				s = "RNDIS_INITIALIZED"; break;
 			 case RNDIS_DATA_INITIALIZED:
 				s = "RNDIS_DATA_INITIALIZED"; break;
-			}; s; }),
+			} s; }),
 			 param->medium,
 			 (param->media_state) ? 0 : param->speed*100,
 			 (param->media_state) ? "disconnected" : "connected",
diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index 0ff3339..eccea1d 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -472,7 +472,7 @@ static int usbg_bot_setup(struct usb_function *f,
 		bot_enqueue_cmd_cbw(fu);
 		return 0;
 		break;
-	};
+	}
 	return -ENOTSUPP;
 }
 
@@ -617,7 +617,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 
 	default:
 		BUG();
-	};
+	}
 	return;
 
 cleanup:
diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index aa5b603..da7d7fc 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -379,7 +379,7 @@ struct debug_buffer {
 		case QH_LOW_SPEED:  tmp = 'l'; break; \
 		case QH_HIGH_SPEED: tmp = 'h'; break; \
 		default: tmp = '?'; break; \
-		}; tmp; })
+		} tmp; })
 
 static inline char token_mark(struct ehci_hcd *ehci, __hc32 token)
 {
diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index fce13bc..55486bd 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -412,7 +412,7 @@ struct debug_buffer {
 			tmp = 'h'; break; \
 		default:		\
 			tmp = '?'; break; \
-		}; tmp; })
+		} tmp; })
 
 static inline char token_mark(struct fotg210_hcd *fotg210, __hc32 token)
 {
diff --git a/drivers/usb/host/fusbh200-hcd.c b/drivers/usb/host/fusbh200-hcd.c
index 299253c..e1c6d85 100644
--- a/drivers/usb/host/fusbh200-hcd.c
+++ b/drivers/usb/host/fusbh200-hcd.c
@@ -402,7 +402,7 @@ struct debug_buffer {
 		case QH_LOW_SPEED:  tmp = 'l'; break; \
 		case QH_HIGH_SPEED: tmp = 'h'; break; \
 		default: tmp = '?'; break; \
-		}; tmp; })
+		} tmp; })
 
 static inline char token_mark(struct fusbh200_hcd *fusbh200, __hc32 token)
 {
diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 6f29aba..935a2dd 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2108,7 +2108,7 @@ static int isp1362_show(struct seq_file *s, void *unused)
 				   default:
 					   s = "?";
 					   break;
-				   };
+				   }
 				   s;}), ep->maxpacket) ;
 		list_for_each_entry(urb, &ep->hep->urb_list, urb_list) {
 			seq_printf(s, "  urb%p, %d/%d\n", urb,
diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index 31b81f9..3fca52e 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -17,7 +17,7 @@
 	case PIPE_BULK:		temp = "bulk"; break; \
 	case PIPE_INTERRUPT:	temp = "intr"; break; \
 	default:		temp = "isoc"; break; \
-	}; temp;})
+	} temp;})
 #define pipestring(pipe) edstring(usb_pipetype(pipe))
 
 /* debug| print the main components of an URB
diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index 5477bf5..79620c3 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1413,7 +1413,7 @@ static int sl811h_show(struct seq_file *s, void *unused)
 			case SL11H_CTL1MASK_SE0: s = " se0/reset"; break;
 			case SL11H_CTL1MASK_K: s = " k/resume"; break;
 			default: s = "j"; break;
-			}; s; }),
+			} s; }),
 			(t & SL11H_CTL1MASK_LSPD) ? " lowspeed" : "",
 			(t & SL11H_CTL1MASK_SUSPEND) ? " suspend" : "");
 
@@ -1446,7 +1446,7 @@ static int sl811h_show(struct seq_file *s, void *unused)
 			case USB_PID_SETUP: s = "setup"; break;
 			case USB_PID_ACK: s = "status"; break;
 			default: s = "?"; break;
-			}; s;}),
+			} s;}),
 			ep->maxpacket,
 			ep->nak_count, ep->error_count);
 		list_for_each_entry (urb, &ep->hep->urb_list, urb_list) {
diff --git a/drivers/usb/host/uhci-pci.c b/drivers/usb/host/uhci-pci.c
index 0f228c4..66edbb2 100644
--- a/drivers/usb/host/uhci-pci.c
+++ b/drivers/usb/host/uhci-pci.c
@@ -178,7 +178,7 @@ static int uhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 		dev_warn(uhci_dev(uhci), "Root hub isn't suspended!\n");
 		rc = -EBUSY;
 		goto done;
-	};
+	}
 
 	/* All PCI host controllers are required to disable IRQ generation
 	 * at the source, so we must turn off PIRQ.
diff --git a/drivers/usb/host/whci/hcd.c b/drivers/usb/host/whci/hcd.c
index ecc88db..1b0888f 100644
--- a/drivers/usb/host/whci/hcd.c
+++ b/drivers/usb/host/whci/hcd.c
@@ -134,7 +134,7 @@ static int whc_urb_enqueue(struct usb_hcd *usb_hcd, struct urb *urb,
 	default:
 		ret = asl_urb_enqueue(whc, urb, mem_flags);
 		break;
-	};
+	}
 
 	return ret;
 }
@@ -160,7 +160,7 @@ static int whc_urb_dequeue(struct usb_hcd *usb_hcd, struct urb *urb, int status)
 	default:
 		ret = asl_urb_dequeue(whc, urb, status);
 		break;
-	};
+	}
 
 	return ret;
 }
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 18e877f..093982a 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -617,7 +617,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				/* case 3 << MUSB_DEVCTL_VBUS_SHIFT: */
 				default:
 					s = "VALID"; break;
-				}; s; }),
+				} s; }),
 				VBUSERR_RETRY_COUNT - musb->vbuserr_retry,
 				musb->port1_status);
 
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index bd4138d..1a5574c 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -443,7 +443,7 @@ static int get_musb_port_mode(struct device *dev)
 	case USB_DR_MODE_OTG:
 	default:
 		return MUSB_PORT_MODE_DUAL_ROLE;
-	};
+	}
 }
 
 static int dsps_create_musb_pdev(struct dsps_glue *glue,
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index b19ed21..b806698 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1121,7 +1121,7 @@ static int musb_gadget_enable(struct usb_ep *ep,
 			case USB_ENDPOINT_XFER_BULK:	s = "bulk"; break;
 			case USB_ENDPOINT_XFER_INT:	s = "int"; break;
 			default:			s = "iso"; break;
-			}; s; }),
+			} s; }),
 			musb_ep->is_in ? "IN" : "OUT",
 			musb_ep->dma ? "dma, " : "",
 			musb_ep->packet_sz);
diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 9a2b8c8..6582a20 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -253,7 +253,7 @@ musb_start_urb(struct musb *musb, int is_in, struct musb_qh *qh)
 			case USB_ENDPOINT_XFER_BULK:	s = "-bulk"; break;
 			case USB_ENDPOINT_XFER_ISOC:	s = "-iso"; break;
 			default:			s = "-intr"; break;
-			}; s; }),
+			} s; }),
 			epnum, buf + offset, len);
 
 	/* Configure endpoint */
diff --git a/drivers/usb/phy/phy-twl4030-usb.c b/drivers/usb/phy/phy-twl4030-usb.c
index 90730c8..2da8b2f 100644
--- a/drivers/usb/phy/phy-twl4030-usb.c
+++ b/drivers/usb/phy/phy-twl4030-usb.c
@@ -337,7 +337,7 @@ static void twl4030_usb_set_mode(struct twl4030_usb *twl, int mode)
 		dev_err(twl->dev, "unsupported T2 transceiver mode %d\n",
 				mode);
 		break;
-	};
+	}
 }
 
 static void twl4030_i2c_access(struct twl4030_usb *twl, int on)
diff --git a/drivers/usb/phy/phy-ulpi-viewport.c b/drivers/usb/phy/phy-ulpi-viewport.c
index 7c22a539..18bb826 100644
--- a/drivers/usb/phy/phy-ulpi-viewport.c
+++ b/drivers/usb/phy/phy-ulpi-viewport.c
@@ -36,7 +36,7 @@ static int ulpi_viewport_wait(void __iomem *view, u32 mask)
 			return 0;
 
 		udelay(1);
-	};
+	}
 
 	return -ETIMEDOUT;
 }
diff --git a/drivers/usb/wusbcore/cbaf.c b/drivers/usb/wusbcore/cbaf.c
index 7f78f30..010f990 100644
--- a/drivers/usb/wusbcore/cbaf.c
+++ b/drivers/usb/wusbcore/cbaf.c
@@ -208,9 +208,9 @@ static int cbaf_check(struct cbaf *cbaf)
 				ar_name = "ASSOCIATE";
 				ar_assoc = 1;
 				break;
-			};
+			}
 			break;
-		};
+		}
 
 		dev_dbg(dev, "Association request #%02u: 0x%04x/%04x "
 			 "(%zu bytes): %s\n",
diff --git a/drivers/usb/wusbcore/devconnect.c b/drivers/usb/wusbcore/devconnect.c
index 33a1278..e538b72 100644
--- a/drivers/usb/wusbcore/devconnect.c
+++ b/drivers/usb/wusbcore/devconnect.c
@@ -973,7 +973,7 @@ int wusb_usb_ncb(struct notifier_block *nb, unsigned long val,
 	default:
 		WARN_ON(1);
 		result = NOTIFY_BAD;
-	};
+	}
 	return result;
 }
 
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 6ad02f5..8ac7712 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -429,7 +429,7 @@ static ssize_t __wa_xfer_setup_sizes(struct wa_xfer *xfer,
 		/* never happens */
 		BUG();
 		result = -EINVAL;	/* shut gcc up */
-	};
+	}
 	xfer->is_inbound = urb->pipe & USB_DIR_IN ? 1 : 0;
 	xfer->is_dma = urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP ? 1 : 0;
 	xfer->seg_size = le16_to_cpu(rpipe->descr.wBlocks)
@@ -488,7 +488,7 @@ static void __wa_xfer_setup_hdr0(struct wa_xfer *xfer,
 		printk(KERN_ERR "FIXME: ISOC not implemented\n");
 	default:
 		BUG();
-	};
+	}
 }
 
 /*


